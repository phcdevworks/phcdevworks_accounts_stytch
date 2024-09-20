# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationSetter, type: :controller do
  controller(ApplicationController) do
    include OrganizationSetter

    def test_action
      set_organization
      render plain: 'OK' unless performed?
    end

    def handle_missing_params_error(message)
      render json: { error: message }, status: :bad_request
    end
  end

  before do
    routes.draw { get 'test_action' => 'anonymous#test_action' }
  end

  let(:organization_service) { instance_double(PhcdevworksAccountsStytch::Stytch::Organization) }

  describe '#set_organization' do
    context 'when the organization ID is found' do
      it 'sets the @organization_id' do
        allow(PhcdevworksAccountsStytch::Stytch::Organization).to receive(:new).and_return(organization_service)
        allow(organization_service).to receive(:find_organization_id_by_slug).with('test-slug').and_return('12345')

        get :test_action, params: { organization_slug: 'test-slug' }

        expect(response.body).to eq('OK')
        expect(controller.instance_variable_get(:@organization_id)).to eq('12345')
      end
    end

    context 'when a PhcdevworksAccountsStytch::Stytch::Error is raised' do
      it 'calls handle_missing_params_error with the error message' do
        allow(PhcdevworksAccountsStytch::Stytch::Organization).to receive(:new).and_return(organization_service)
        allow(organization_service).to receive(:find_organization_id_by_slug).with('test-slug').and_raise(PhcdevworksAccountsStytch::Stytch::Error.new(error_message: 'Something went wrong'))

        get :test_action, params: { organization_slug: 'test-slug' }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Stytch Error - Message: Something went wrong' })
      end
    end
  end
end

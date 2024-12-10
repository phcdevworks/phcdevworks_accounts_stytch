# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::AuthHelper do
  let(:dummy_class) do
    Class.new do
      include PhcdevworksAccountsStytch::Stytch::AuthHelper

      attr_accessor :session

      def initialize
        @session = {}
      end

      def redirect_to(path, options = {}); end

      def login_path
        :login_path
      end
    end
  end

  let(:helper) { dummy_class.new }

  describe '#logged_in?' do
    context 'when user_id exists in session' do
      before do
        helper.session[:user_id] = '123'
      end

      it 'returns true' do
        expect(helper.logged_in?).to be true
      end
    end

    context 'when user_id does not exist in session' do
      before do
        helper.session[:user_id] = nil
      end

      it 'returns false' do
        expect(helper.logged_in?).to be false
      end
    end
  end

  describe '#require_login' do
    context 'when user is logged in' do
      before do
        helper.session[:user_id] = '123'
        allow(helper).to receive(:redirect_to)
      end

      it 'does not redirect' do
        helper.require_login
        expect(helper).not_to have_received(:redirect_to)
      end
    end

    context 'when user is not logged in' do
      before do
        helper.session[:user_id] = nil
        allow(helper).to receive(:redirect_to)
      end

      it 'redirects to login path with alert' do
        helper.require_login
        expect(helper).to have_received(:redirect_to).with(
          :login_path,
          alert: 'You must be logged in to access this section'
        )
      end
    end
  end
end

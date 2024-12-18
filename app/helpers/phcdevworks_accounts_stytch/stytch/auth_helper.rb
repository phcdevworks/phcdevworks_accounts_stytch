module PhcdevworksAccountsStytch
  module Stytch
    module AuthHelper
      def require_login
        return if logged_in?

        respond_unauthorized
      end

      def logged_in?
        !!session[:user_id]
      end

      private

      def respond_unauthorized
        respond_to do |format|
          format.json do
            render json: { error: 'Unauthorized', message: 'You must be logged in to access this resource.' },
                   status: :unauthorized
            return
          end
          format.html do
            render file: Rails.root.join('public/401.html'),
                   status: :unauthorized,
                   layout: false
            return
          end
          format.any do
            head :unauthorized
            return
          end
        end
      end
    end
  end
end

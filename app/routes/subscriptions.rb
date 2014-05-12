module Georelevent
  module Routes
    class Subscriptions < Grape::API
      version 'v1', using: :header, vendor: 'georelevent'
      format :json

      desc 'Retrieve a subscription'

      params do
        requires :id, type: Integer
      end

      get '/subscriptions/:id' do
        Subscription.first!(id: params[:id])
      end

      desc 'Create a new subscription'

      params do
        requires :subscription, type: Hash do
          requires :geom, type: String
        end
      end

      post '/subscriptions' do
        Subscription.create(params[:subscription])
      end
    end
  end
end

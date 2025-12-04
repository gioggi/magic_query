# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MagicQuery::Rails::MagicQueryController, type: :controller do
  controller(described_class) do
    # Test controller
  end

  before do
    routes.draw do
      post 'magic_query/generate', to: 'magic_query/rails/magic_query#generate'
    end
  end

  describe 'POST #generate' do
    let(:user_input) { 'find all users' }
    let(:generated_sql) { 'SELECT * FROM users' }

    before do
      generator = instance_double(MagicQuery::QueryGenerator)
      allow(generator).to receive(:generate).and_return(generated_sql)
      allow(controller).to receive(:set_generator)
      controller.instance_variable_set(:@generator, generator)
    end

    context 'with valid query parameter' do
      it 'returns success status' do
        post :generate, params: { query: user_input }, format: :json
        expect(response).to have_http_status(:success)
      end

      it 'returns generated SQL in response' do
        post :generate, params: { query: user_input }, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response['sql']).to eq(generated_sql)
      end

      it 'returns query in response' do
        post :generate, params: { query: user_input }, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response['query']).to eq(user_input)
      end
    end

    context 'with input parameter' do
      it 'uses input parameter' do
        post :generate, params: { input: user_input }, format: :json
        expect(response).to have_http_status(:success)
      end
    end

    context 'with missing query parameter' do
      it 'returns bad request status' do
        post :generate, format: :json
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error message' do
        post :generate, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Query parameter is required')
      end
    end

    context 'when generator raises MagicQuery::Error' do
      before do
        generator = instance_double(MagicQuery::QueryGenerator)
        allow(generator).to receive(:generate).and_raise(MagicQuery::Error, 'Test error')
        controller.instance_variable_set(:@generator, generator)
      end

      it 'returns unprocessable entity status' do
        post :generate, params: { query: user_input }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message in response' do
        post :generate, params: { query: user_input }, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Test error')
      end
    end
  end
end

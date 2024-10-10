# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user 
  end

  describe 'POST #assign' do
    context 'when user assigns a device to self' do
      let(:serial_number) { '123456' }

      before do
        post :assign, params: { new_owner_id: user.id, serial_number: serial_number }
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end
    end

  end
end
require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  let(:api_key) { create(:api_key) }
  let(:user) { api_key.bearer }

  describe 'POST #assign' do
    subject(:assign) do
      post :assign,
           params: { new_owner_id: new_owner_id, serial_number: '123456' },
           session: { token: user.api_keys.first.token }
    end

    before do
      allow(AssignDeviceToUser).to receive(:new).and_return(assign_device_service)
    end

    let(:assign_device_service) { instance_double(AssignDeviceToUser) }

    context 'when the user is authenticated' do
      context 'when user assigns a device to another user' do
        let(:new_owner_id) { create(:user).id }

        before do
          allow(assign_device_service).to receive(:call).and_raise(RegistrationError::Unauthorized)
        end

        it 'returns an unauthorized response' do
          assign
          expect(response.code).to eq('422')
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Unauthorized' })
        end
      end

      context 'when user assigns a device to self' do
        let(:new_owner_id) { user.id }

        before do
          allow(assign_device_service).to receive(:call).and_return(true)
        end

        it 'returns a success response' do
          assign
          expect(response).to be_successful
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'returns an unauthorized response' do
        post :assign
        expect(response).to be_unauthorized
      end
    end
  end

    describe 'POST #unassign' do
    subject(:unassign) do
      post :unassign, params: { serial_number: '123456' }, session: { token: user.api_keys.first.token }
    end

    before do
      allow(ReturnDeviceFromUser).to receive(:new).and_return(return_device_service)
    end

    let(:return_device_service) { instance_double(ReturnDeviceFromUser) }

    context 'when the user is authenticated' do
      before do
        allow(return_device_service).to receive(:call).and_return(true)
      end

      it 'returns a success response' do
        unassign
        expect(response).to be_successful
      end

      context 'when the user tries to unassign a device they do not own' do
        before do
          allow(return_device_service).to receive(:call).and_raise(AssigningError::AlreadyUsedOnOtherUser)
        end

        it 'returns an unauthorized response' do
          unassign
          expect(response.code).to eq('422')
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Unauthorized' })
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'returns an unauthorized response' do
        post :unassign
        expect(response).to be_unauthorized
      end
    end
  end
end
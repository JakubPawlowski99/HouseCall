# frozen_string_literal: true

class DevicesController < ApplicationController
  before_action :authenticate_user!, only: %i[assign unassign]

  def assign
    begin
      result = AssignDeviceToUser.new(
        requesting_user: @current_user,
        serial_number: params[:serial_number],
        new_device_owner_id: params[:new_owner_id]
      ).call
      if result
        head :ok
      else
        render json: { error: 'Assignment failed' }, status: :unprocessable_entity
      end
    rescue RegistrationError::Unauthorized => e
      Rails.logger.error "Unauthorized error: #{e.message}"
      render json: { error: 'Unauthorized' }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error "Unexpected error: #{e.message}"
      render json: { error: 'Unexpected error' }, status: :internal_server_error
    end
  end

  def unassign
    ReturnDeviceFromUser.new(user: @requesting_user, serial_number: @serial_number).call
    render json: { success: true }, status: :ok
  rescue AssigningError::AlreadyUsedOnOtherUser
    render json: { error: 'Unauthorized' }, status: :unprocessable_entity
  end

  private

  def device_params
    params.permit(:new_owner_id, :serial_number)
  end
end
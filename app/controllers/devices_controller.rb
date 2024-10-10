# frozen_string_literal: true

class DevicesController < ApplicationController
  before_action :authenticate_user!, only: %i[assign unassign]
  def assign
    if params[:new_owner_id] != @current_user.id
      return render json: { error: 'Unauthorized' }, status: :unprocessable_entity
    end
  
    AssignDeviceToUser.new(
      requesting_user: @current_user,
      serial_number: params[:serial_number],
      new_owner_id: params[:new_owner_id]
    ).call
    head :ok
  end

  def unassign
    # TODO: implement the unassign action
  end

  private

  def device_params
    params.permit(:new_owner_id, :serial_number)
  end
end

class HooksController < ApplicationController
  before_action :set_hook, only: [:show, :destroy]

  # GET /hooks
  # GET /hooks.json
  def index
    @hooks = Hook.all
  end

  # GET /hooks/1
  # GET /hooks/1.json
  def show
  end

  def callback
    h = Hook.new
    h.payload = params
    h.save
    head :ok
  end

  # DELETE /hooks/1
  # DELETE /hooks/1.json
  def destroy
    @hook.destroy
    respond_to do |format|
      format.html { redirect_to hooks_url, notice: 'Hook was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_hook
    @hook = Hook.find(params[:id])
  end
end

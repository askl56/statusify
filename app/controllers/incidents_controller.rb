class IncidentsController < ApplicationController
  skip_before_filter :verify_authenticity_token if ENV['STRESS-TEST']
  before_action :require_login

  def new
    @incident ||= current_user.incidents.new
    @incident.events.build
  end

  def create
    @incident = current_user.incidents.new(incident_params)
    if @incident.save
      # Handle successful save
      flash[:success] = 'Incident created successfully.'
      redirect_to root_path
      response.headers['status'] = 'success'
    else
      response.headers['status'] = 'failed'
      render 'incidents/new'
    end
  end

  def edit
    @incident ||= Incident.find_by_id(params[:id])
    @event = Event.find_by_incident_id(params[:id])
    redirect_to root_path if @incident.nil?
  end

  def update
    # Builds a new event for each update.
    @incident = Incident.find_by_id(params[:id])
    @incident.name = incident_params[:name]
    @incident.component = incident_params[:component]
    event_params = { message: incident_params[:event][:message], status: incident_params[:event][:status] }
    @event = @incident.events.build(event_params)
    if @incident.save || @event.save
      response.headers['status'] = 'success'
      flash[:success] = 'Updated incident successfully.'
      redirect_to root_path
    else
      response.headers['status'] = 'failed'
      flash[:danger] = 'Please fill all entries.'
      redirect_to "/incidents/#{@incident.id}"
    end
  end

  def delete
    i = Incident.find_by_id(params[:id])
    if !!i
      response.headers['status'] = 'success'
      i.delete
      flash[:success] = 'Incident deleted successfully.'
    else
      response.headers['status'] = 'failed'
      flash[:danger] = 'Failed to delete incident.'
    end
    redirect_to root_url
  end

  def deactivate
    @incident = Incident.find_by_id(params[:id])
    if @incident
      @incident.active = false
      @incident.save
      flash[:success] = 'Deactivated incident successfully.'
    end
    redirect_to root_path
  end

  private

  def incident_params
    params.require(:incident).permit(:name, :status, :component, events_attributes: [:status, :message], event: [:status, :message])
  end
end

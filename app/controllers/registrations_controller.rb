class RegistrationsController < ::ApplicationController
  include ::SslRequirement
  ssl_required :new, :create if Rails.env.production?

  # GET /registrations/1
  # GET /registrations/1.json
  def show
    @registration = Registration.find(params[:id])
    @event = @registration.event
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @registration }
    end
  end

  # GET /registrations/new
  # GET /registrations/new.json
  def new
    @event = Event.find(params[:event_id])
    @registration = @event.registrations.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @registration }
    end
  end

  # POST /registrations
  # POST /registrations.json
  def create
    @event = Event.find(params[:event_id])
    respond_to do |format|
      begin
        raise "This class has already started" unless @event.upcoming?
        @registration = Registration.create_stripe_registration(@event, params)
        if @registration.errors[:base].empty?
          session[:registration_id] = @registration.id
          format.html { redirect_to event_registration_path(@event, @registration), notice: 'Registration was successfully created.' }
          format.json { render json: @registration, status: :created, location: @registration }
        else
          flash[:error] = @registration.errors[:base].join('\n')
          format.html { render action: "new" }
          format.json { render json: @registration.errors, status: :unprocessable_entity }
        end
      rescue => e
        flash[:error] = e.message
        format.html { render action: "new" }
        format.json { render json: e.message, status: :unprocessable_entity }
      end
    end
  end
end

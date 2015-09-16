class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  # GET /appointments
  # GET /appointments.json
  def index
    @appointments = Appointment.all
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments
  # POST /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to @appointment, notice: 'Appointment was successfully created.' }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  def createAppt
    appt = Appointment.new
    if params[:player1ID] == current_user.game_id and params[:gametime] != ""
      appt.gametime = params[:gametime]
      appt.position = params[:position]
      appt.player1ID = current_user.game_id
      appt.save
      render json: {status: 1}.to_json
    else
      render json: {status: 0}.to_json
    end
  end

  def getApptByPage
    # use curtime to filter, only show records with player2ID==""
    appt = Appointment.where(player2ID: nil).where("gametime >= ?", params[:curtime]).order(gametime: :asc)
    apptarray = []
    for each in appt
      aplayer = User.find_by_game_id(each.player1ID)
      anappt = {gametime: each.gametime, player1ID: each.player1ID, position:each.position, rankb: aplayer.rankb, ranks:aplayer.ranks, rankBadge:aplayer.rankBadge, apptID: each.id}
      apptarray.push(anappt)
    end
    render json: {allAppts: apptarray}.to_json
  end

  def getAppt
    # use curtime to filter, only show records with player2ID==""
    appt = Appointment.where(player2ID: nil).where("gametime >= ?", params[:curtime]).order(gametime: :asc)
    apptarray = []
    for each in appt
      aplayer = User.find_by_game_id(each.player1ID)
      anappt = {gametime: each.gametime, player1ID: each.player1ID, position:each.position, rankb: aplayer.rankb, ranks:aplayer.ranks, rankBadge:aplayer.rankBadge, apptID: each.id}
      apptarray.push(anappt)
    end
    render json: {allAppts: apptarray}.to_json
  end

  def getMyAppt
    # use curtime to filter, only show records with player2ID==""
    appt = Appointment.where.not(player2ID: nil).where("gametime >= ? and (player1ID = ? or player2ID = ?)", params[:curtime], current_user.game_id, current_user.game_id).order(gametime: :asc)
    apptarray = []
    for each in appt
      aplayer = User.find_by_game_id(each.player1ID)
      anappt = {gametime: each.gametime, player1ID: each.player1ID, player2ID: each.player2ID, apptID: each.id}
      apptarray.push(anappt)
    end
    render json: {allAppts: apptarray}.to_json
  end

  def getTotalPage
    appt = 0;
    if params[:pageState] == "0"
      appt = Appointment.where(player2ID: nil).where("gametime >= ?", params[:curtime]).count
    elsif params[:pageState] == "1"
      appt = Appointment.where("(player1ID = ? or player2ID=?) and gametime >= ?", current_user.game_id, current_user.game_id, params[:curtime]).count
    end
    appt = (appt / 12.0).ceil
    render json: {totalApptPage: appt}.to_json
  end

  def joinAppt
    appt = Appointment.find_by_id(params[:apptID])
    if not(appt.player1ID == current_user.game_id)
      appt.player2ID = current_user.game_id
      appt.save
      render json: {status: 1}.to_json
    else
      render json: {status: 0}.to_json
    end
  end

  def cancelAppt
    appt = Appointment.find_by_id(params[:apptID])
    if appt.player1ID == current_user.game_id
      appt.player1ID = appt.player2ID
      appt.player2ID = nil
    elsif appt.player2ID == current_user.game_id
      appt.player2ID = nil
    end
    if appt.save
      render json: {status: 1}.to_json
    else
      render json: {status: 2}.to_json
    end
  end

  # PATCH/PUT /appointments/1
  # PATCH/PUT /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to @appointment, notice: 'Appointment was successfully updated.' }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to appointments_url, notice: 'Appointment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appointment_params
      params.require(:appointment).permit(:gametime, :player1ID, :player2ID)
    end
end

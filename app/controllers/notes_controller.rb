class NotesController < BelongsToUser
  before_filter :get_note, :except => [:index, :new, :create]

  def index
    respond_to do |format|
      format.html {
        # Data
        @notes = @current_user.all_notes.paginate :page => params[:page]
      }
      format.amline {
        notes = @current_user.all_notes
        @data = []
        day = params[:period].to_i.days.ago.to_date
        while (day <= Date.today)
          todays_note = notes.find { |x| x.date == day }
          str = todays_note ? todays_note.date.strftime("%b %d") + ": " + todays_note.note : nil
          @data << { :date => day, :note => str }
          day += 1
        end
        # Send data
        render :layout => false
      }
    end
  end

  def new
    @notatables = notatable_list
    @note = Note.new
  end

  def create
    @note = Note.create(params[:note])
    @note.notatable_string = params[:note][:notatable_string]
    if @note.save
      redirect_to user_notes_path(@user)
    else
      @notatables = notatable_list
      render :action => "new"
    end
  end

  def edit
    @notatables = notatable_list
  end

  def update
    @note.update_attributes(params[:note])
    @note.notatable_string = params[:note][:notatable_string]
    if @note.save
      redirect_to user_notes_path(@user)
    else
      @notatables = notatable_list
      render :action => "edit"
    end
  end

  def destroy
    @note.destroy
    redirect_to user_notes_path(@user)
  end

private

  def get_note
    @note = Note.find(params[:id])
  end

  def notatable_list
    notatable = []
    notatable << ["General", @current_user.class.name + ";" + @current_user.id.to_s]
    @current_user.electricity_accounts.each { |acc| notatable << [acc.name, acc.class.name.to_s + ";" + acc.id.to_s] }
    @current_user.gas_accounts.each { |acc| notatable << [acc.name, acc.class.name.to_s + ";" + acc.id.to_s] }
    @current_user.vehicles.each { |acc| notatable << [acc.name, acc.class.name.to_s + ";" + acc.id.to_s] }
    return notatable
  end

end

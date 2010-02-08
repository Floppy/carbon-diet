class NotesController < AuthenticatedController

  def index
    redirect_to :action => 'list'
  end

  def list
    respond_to do |format|
      format.html {
        # Data
        @notes = @current_user.notes.paginate :page => params[:page]
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

  def edit
    @note = params[:id] ? @current_user.all_notes.find { |x| x.id == params[:id].to_i } : Note.new    
    @notatables = notatable_list
    if request.post?
      @note.update_attributes(params[:note])
      @note.notatable_string = params[:note][:notatable_string]
      index if @note.save
    end
  end

  def destroy
    note = @current_user.all_notes.find { |x| x.id == params[:id].to_i }
    note.destroy unless note.nil?
    index
  end

private

  def notatable_list
    notatable = []
    notatable << ["General", @current_user.class.name + ";" + @current_user.id.to_s]
    @current_user.electricity_accounts.each { |acc| notatable << [acc.name, acc.class.name.to_s + ";" + acc.id.to_s] }
    @current_user.gas_accounts.each { |acc| notatable << [acc.name, acc.class.name.to_s + ";" + acc.id.to_s] }
    @current_user.vehicles.each { |acc| notatable << [acc.name, acc.class.name.to_s + ";" + acc.id.to_s] }
    return notatable
  end

end

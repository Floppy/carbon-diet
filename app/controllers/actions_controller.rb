class ActionsController < ApplicationController
  before_filter :check_logged_in, :except => ["view"]
  before_filter :get_current_user, :only => ["view"]

  def index
    @totals = get_totals
    @pagename = "Take action"
    @actions = get_actions(5)
    session[:num_actions] = 5
  end

  def view
    @action = Action.find_by_id(params[:id])
    @pagename = @action.title
  rescue
    flash[:notice] = "Unknown action!"
    redirect_to_main_page
  end

  def complete
    completed_action = CompletedAction.new
    completed_action.user = @current_user
    @action = Action.find(params[:id])
    completed_action.action = @action
    completed_action.done = params[:done]
    completed_action.save
    session[:num_actions] -= 1 rescue nil
    @actions = get_actions(1, session[:num_actions])
    session[:num_actions] += 1 rescue nil
    render :action => 'another'
  end
  
  def another    
    @actions = get_actions(1, session[:num_actions])
    session[:num_actions] += 1 rescue nil
  end

  def completed
    # Page name
    @pagename = "Completed actions"
    # Data
    @completed_actions = @current_user.completed_actions.paginate :page => params[:page], :order => "created_at DESC"
  end

  def uncomplete
    completed_action = CompletedAction.find(params[:id])
    completed_action.destroy
    redirect_to :action => 'completed'
  end

protected

  def get_totals
    @current_user.calculate_totals(28)
  end

end

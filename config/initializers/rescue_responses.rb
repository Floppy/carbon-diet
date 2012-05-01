class ActionController::Forbidden < StandardError
end
class ActionController::Unauthorized < StandardError
end

ActionDispatch::ShowExceptions.rescue_responses.update('ActionController::Forbidden' => :forbidden)
ActionDispatch::ShowExceptions.rescue_responses.update('ActionController::Unauthorized' => :unauthorized)

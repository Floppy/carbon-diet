class ActionController::Forbidden < StandardError
end
class ActionController::Unauthorized < StandardError
end

ActionController::Base.rescue_responses['ActionController::Forbidden'] = :forbidden
ActionController::Base.rescue_responses['ActionController::Unauthorized'] = :unauthorized

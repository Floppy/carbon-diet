class ActionController::Forbidden < StandardError
end
class ActionController::Unauthorized < StandardError
end

CarbonDiet::Application.config.action_dispatch.rescue_responses.update('ActionController::Forbidden' => :forbidden)
CarbonDiet::Application.config.action_dispatch.rescue_responses.update('ActionController::Unauthorized' => :unauthorized)

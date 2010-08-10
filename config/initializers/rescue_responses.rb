class PermissionDenied < Exception
end

ActionController::Base.rescue_responses['PermissionDenied'] = :forbidden

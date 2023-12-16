Rails.application.config.session_store :cookie_store, key: '_Rustoff_back', expire_after: 14.days, httponly: true
Rails.application.config.action_dispatch.cookies_serializer = :hybrid

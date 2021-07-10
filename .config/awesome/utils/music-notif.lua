local naughty = require("naughty")

music_noti = {}
music_noti.notification = nil
function music_noti:notify (title, message, image)
  if self.notification and not self.notification.is_expired then
    self.notification:destroy(1)

    if not client.focus.fullscreen then
      self.notification = naughty.notification {
          title = title,
          message = message,
          image = image,
          timeout = 10,
          ignore_suspend = false
      }
    end
    -- self.notification.message = message -- broken right now
  else
    if not client.focus.fullscreen then
      self.notification = naughty.notification {
          title = title,
          message = message,
          image = image,
          timeout = 10,
          ignore_suspend = false
      }
    end
  end
end

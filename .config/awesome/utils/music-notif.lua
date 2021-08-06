local naughty = require("naughty")

_G.music_noti = {}
music_noti.notification = nil

function music_noti:notify(title, message, image, id)
  if self[id] and not self[id].is_expired then
    self[id]:destroy(1)

    if not client.focus.fullscreen then
      self[id] = naughty.notification {
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
      music_noti[id] = naughty.notification {
        title = title,
        message = message,
        image = image,
        timeout = 10,
        ignore_suspend = false
      }
    end
  end
end

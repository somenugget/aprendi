/* eslint-disable no-restricted-globals,no-console */

self.addEventListener('push', (event) => {
  const notificationData = JSON.parse(event.data.text())

  const options = {
    title: notificationData.title,
    body: notificationData.body,
    icon: notificationData.icon,
  }

  console.log(options)

  event.waitUntil(
    self.registration.showNotification(notificationData.title, options),
  )
})

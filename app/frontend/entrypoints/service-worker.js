/* eslint-disable no-restricted-globals,no-console */

self.addEventListener('push', (event) => {
  const notificationData = JSON.parse(event.data.text())

  const options = {
    title: notificationData.title,
    body: notificationData.body,
    icon: 'http://localhost:3000/pwa-maskable-512x512.png',
  }

  console.log(options)

  event.waitUntil(
    self.registration.showNotification(notificationData.title, options),
  )
})

self.addEventListener('notificationclick', (event) => {
  // eslint-disable-next-line no-undef
  const promiseChain = clients
    .matchAll({
      type: 'window',
      includeUncontrolled: true,
    })
    .then((windowClients) => {
      event.notification.close()

      if (windowClients.length) {
        return windowClients[0].focus()
      }
      // eslint-disable-next-line no-undef
      return clients.openWindow('/dashboard')
    })

  event.waitUntil(promiseChain)
})

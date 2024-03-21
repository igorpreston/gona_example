// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>

// console.log('Vite ⚡️ Rails')

// If using a TypeScript entrypoint file:
//     <%= vite_typescript_tag 'application' %>
//
// If you want to use .jsx or .tsx, add the extension:
//     <%= vite_javascript_tag 'application.jsx' %>

// console.log('Visit the guide for more information: ', 'https://vite-ruby.netlify.app/guide/rails')

// Example: Load Rails libraries in Vite.
//
import * as Turbo from '@hotwired/turbo'
Turbo.start()
//
// import ActiveStorage from '@rails/activestorage'
// ActiveStorage.start()
//
// // Import all channels.
// const channels = import.meta.globEager('./**/*_channel.js')

// Example: Import a stylesheet in app/frontend/index.css
// import '~/index.css'

import "chartkick/chart.js"
import "mapkick/bundle"
import { Application } from '@hotwired/stimulus'
import { registerControllers } from 'stimulus-vite-helpers'

const application = Application.start()
const controllers = import.meta.glob('@/controllers/*_controller.js', { eager: true })

registerControllers(application, controllers)

import Dropdown from 'stimulus-dropdown'
application.register("dropdown", Dropdown)

import TextareaAutogrow from 'stimulus-textarea-autogrow'
application.register("textarea-autogrow", TextareaAutogrow)

import CharacterCounter from 'stimulus-character-counter'
application.register('character-counter', CharacterCounter)

import ScrollTo from 'stimulus-scroll-to'
application.register('scroll-to', ScrollTo)

import PlacesAutocomplete from 'stimulus-places-autocomplete'
application.register('places', PlacesAutocomplete)

import Notification from 'stimulus-notification'
application.register('notification', Notification)

import Sortable from 'stimulus-sortable'
application.register('sortable', Sortable)

import Clipboard from 'stimulus-clipboard'
application.register('clipboard', Clipboard)

import NestedForm from 'stimulus-rails-nested-form'
application.register('nested-form', NestedForm)

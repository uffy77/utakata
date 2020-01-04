/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import "../stylesheets/application.scss"
import Rails from "rails-ujs"
import Turbolinks from "turbolinks"
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import "@fortawesome/fontawesome-free/js/all"
import "bootstrap.native"

document.addEventListener("turbolinks:load", () => {
  global.BSN.initCallback(document.body)

  const toasts = document.querySelectorAll("[data-dismiss=toast]")
  if (toasts) {
    toasts.forEach((toast) => {
      console.log(toasts)
      console.log(toast)
      console.log(toast["Toast"])
      toast["Toast"].show()
    })
  }
})

Rails.start()
Turbolinks.start()
const application = Application.start()
const context = require.context("controllers", true, /.js$/)
application.load(definitionsFromContext(context))

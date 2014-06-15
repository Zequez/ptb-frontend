#= require 'timeSince'
#= require_tree './shim'
#= require_tree './templates'
#= require PTB
#= require services
#= require routes

#= require page_ctrl
#= require table_ctrl

#= require eventable
#= require elements
#= require services/data_service
#= require services/i18n

#= require routes/mapping_data.js
#= require routes/mapper
#= require routes/map
#= require routes/route
#= require routes/router

#= require games
#= require game

#= require filters
#= require filters/filters_container
#= require filters/base_filter
#= require filters/flags_filter
#= require filters/number_filter
#= require filters/date_filter
#= require filters/text_filter
#= require filters/array_filter

#= require sorter

#= require tooltipler

#= require_self
#= require little_scripts


window.app = new PTB.PageCtrl
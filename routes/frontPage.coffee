module.exports.get = (next) ->
  yield this.render 'index', { 
    mainPage: true,
    contentClass: 'main'
  }

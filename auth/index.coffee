passport = require 'koa-passport'
LocalStrategy = require('passport-local').Strategy
db = require '../database'
Role = require '../models/role'
User = require '../models/user'

passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (user, done) ->
  done null, user
  # db.getUserByIdPromise id
  #   .then (resp) ->
  #     row = resp[0][0]
  #     console.log row
  #     role = new Role row.roleId, row.roleName
  #     user = new User row.id, row.username, row.firstName, row.lastName, row.active, role
  #     done null, user
  #   .catch (error) ->
  #     console.log error
  #     done error

passport.use(new LocalStrategy((username, password, done) ->
  db.getUserPromise username
    .then (resp) ->
      rows = resp[0]
      if rows.length
        if User.checkPassword rows[0].password, password
          if rows[0].active
            role = new Role rows[0].roleId, rows[0].roleName
            user = new User rows[0].id, rows[0].username, rows[0].firstName, rows[0].lastName, rows[0].active, role
            done null, user
          else
            done(null, false, { message: 'The account is not active' })
        else
          console.log 'Password error'
          done(null, false, { message: 'Wrong password' })
      else
        done(null, false, { message: 'User not found' })
    .catch (errror) ->
      done error
))

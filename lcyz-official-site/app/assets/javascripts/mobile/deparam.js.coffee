!(($) ->

  $.deparam = (params, coerce) ->
    if !params
      params = window.location.href.split('?')[1] or ''
    obj = {}
    coerce_types =
      'true': !0
      'false': !1
      'null': null
    # Iterate over all name=value pairs.
    $.each params.replace(/\+/g, ' ').split('&'), (j, v) ->
      param = v.split('=')
      key = decodeURIComponent(param[0])
      val = undefined
      cur = obj
      i = 0
      keys = key.split('][')
      keys_last = keys.length - 1
      # If the first keys part contains [ and the last ends with ], then []
      # are correctly balanced.
      if /\[/.test(keys[0]) and /\]$/.test(keys[keys_last])
        # Remove the trailing ] from the last keys part.
        keys[keys_last] = keys[keys_last].replace(/\]$/, '')
        # Split first keys part into two parts on the [ and add them back onto
        # the beginning of the keys array.
        keys = keys.shift().split('[').concat(keys)
        keys_last = keys.length - 1
      else
        # Basic 'foo' style key.
        keys_last = 0
      # Are we dealing with a name=value pair, or just a name?
      if param.length == 2
        val = decodeURIComponent(param[1])
        # Coerce values.
        if coerce
          val = if val and !isNaN(val) then +val else if val == 'undefined' then undefined else if coerce_types[val] != undefined then coerce_types[val] else val
          # string
        if keys_last
          # Complex key, build deep object structure based on a few rules:
          # * The 'cur' pointer starts at the object top-level.
          # * [] = array push (n is set to array length), [n] = array if n is
          #   numeric, otherwise object.
          # * If at the last keys part, set the value.
          # * For each keys part, if the current level is undefined create an
          #   object or array based on the type of the next keys part.
          # * Move the 'cur' pointer to the next level.
          # * Rinse & repeat.
          while i <= keys_last
            key = if keys[i] == '' then cur.length else keys[i]
            cur = cur[key] = if i < keys_last then cur[key] or (if keys[i + 1] and isNaN(keys[i + 1]) then {} else []) else val
            i++
        else
          # Simple key, even simpler rules, since only scalars and shallow
          # arrays are allowed.
          if $.isArray(obj[key])
            # val is already an array, so push on the next value.
            obj[key].push val
          else if obj[key] != undefined
            # val isn't an array, but since a second value has been specified,
            # convert val into an array.
            obj[key] = [
              obj[key]
              val
            ]
          else
            # val is a scalar.
            obj[key] = val
      else if key
        # No value was defined, so set something meaningful.
        obj[key] = if coerce then undefined else ''
      return
    obj

  return
)($)

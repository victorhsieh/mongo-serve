require! {express, mongodb, fs}
md = require('node-markdown').Markdown;

mongodb_config =
    'law':
        url: \mongodb://g0v:readonly@ds049237.mongolab.com:49237/twlaw
        list_fields: {+name, +status, -_id}
        query_id_field: \name
    'company':
        url: \mongodb://g0v:readonly@ds049347.mongolab.com:49347/company
        list_fields: {+統一編號, +公司名稱, -_id}
        query_id_field: \公司名稱
    'law-progress':
        url: \mongodb://g0v:readonly@ds043467.mongolab.com:43467/law-progress
        list_fields: {+proposal_name, +proposal_id, +status, -_id, +progress}
        query_id_field: \proposal_id

list_doc = (type, {q={}, f={}, sk=0, l=100}, cb) ->
    unless type? and mongodb_config[type]?
        cb!
        return

    config = mongodb_config[type]
    err, db <- mongodb.Db.connect config.url
    err, coll <- db.collection type

    options = fields: config.list_fields, sk: sk, limit: l
    options.fields <<<< f if f
    err, docs <- coll.find(q, options).toArray
    cb docs

query_doc = (type, name, param, cb) ->
    unless type? and mongodb_config[type]?
        cb!
        return
    config = mongodb_config[type]
    err, db <- mongodb.Db.connect config.url
    err, coll <- db.collection type
    condition = {}
    condition[config.query_id_field] = name
    err, doc <- coll.find(condition, {-_id}).nextObject
    cb doc

port = (process.env.VMC_APP_PORT || 3000)
host = (process.env.VCAP_APP_HOST || 'localhost')

app = express!

renderJson = (res, obj) ->
    res.writeHead 200,
        'Content-Type': 'application/json'
        'Access-Control-Allow-Origin': '*'
    res.end JSON.stringify obj

parse_param = (req, param) ->
    try
        return JSON.parse req.query[param]
    catch
        return void

app.get '/favicon.ico', (req, res) ->
    res.writeHead 404
    res.end "Not found"

app.get '/:type/by/:field/:value', (req, res) ->
    fields = {}
    fields[req.params.field] = decodeURIComponent req.params.value
    list_doc req.params.type, {f: fields, q: req.query}, (doc) ->
        renderJson res, doc

app.get '/:type/:name', (req, res) ->
    query_doc req.params.type, decodeURIComponent(req.params.name), req.query, (doc) ->
        renderJson res, doc

app.get '/:type', (req, res) ->
    find_param = {
        q: parse_param(req, 'q') ? {}
        f: parse_param(req, 'f') ? {}
        sk: parse_param(req, 'sk') ? 0
        l: parse_param(req, 'l') ? 100
    }
    list_doc req.params.type, find_param, (docs) ->
        renderJson res, docs ? {error: 'not found'}

app.get '/', (req, res) ->
    html = fs.readFileSync \views/api.md, \utf8
    res.render 'home.jade', body: md(html, true)


app.use express.static "#__dirname/static"

app.listen port

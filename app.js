var express, mongodb, fs, md, mongodb_config, list_doc, query_doc, port, host, app, renderJson;
express = require('express');
mongodb = require('mongodb');
fs = require('fs');
md = require('node-markdown').Markdown;
mongodb_config = {
  'law': {
    url: 'mongodb://g0v:readonly@ds049237.mongolab.com:49237/twlaw',
    list_fields: {
      name: true,
      status: true,
      _id: false
    },
    query_id_field: 'name'
  },
  'company': {
    url: 'mongodb://g0v:readonly@ds049347.mongolab.com:49347/company',
    list_fields: {
      統一編號: true,
      公司名稱: true,
      _id: false
    },
    query_id_field: '公司名稱'
  }
};
list_doc = function(type, param, cb){
  var config;
  if (!(type != null && mongodb_config[type] != null)) {
    cb();
    return;
  }
  config = mongodb_config[type];
  return mongodb.Db.connect(config.url, function(err, db){
    return db.collection(type, function(err, coll){
      var options;
      options = {
        fields: config.list_fields,
        skip: 0,
        limit: 10
      };
      import$(options, param);
      return coll.find({}, options).toArray(function(err, docs){
        return cb(docs);
      });
    });
  });
};
query_doc = function(type, name, param, cb){
  var config;
  if (!(type != null && mongodb_config[type] != null)) {
    cb();
    return;
  }
  config = mongodb_config[type];
  return mongodb.Db.connect(config.url, function(err, db){
    return db.collection(type, function(err, coll){
      var condition;
      condition = {};
      condition[config.query_id_field] = name;
      return coll.find(condition, {
        _id: false
      }).nextObject(function(err, doc){
        return cb(doc);
      });
    });
  });
};
port = process.env.VMC_APP_PORT || 3000;
host = process.env.VCAP_APP_HOST || 'localhost';
app = express();
renderJson = function(res, obj){
  res.writeHead(200, {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*'
  });
  return res.end(JSON.stringify(obj));
};
app.get('/:type/:name', function(req, res){
  return query_doc(req.params.type, decodeURIComponent(req.params.name), req.query, function(doc){
    return renderJson(res, doc);
  });
});
app.get('/:type', function(req, res){
  return list_doc(req.params.type, req.query, function(docs){
    return renderJson(res, docs != null
      ? docs
      : {
        error: 'not found'
      });
  });
});
app.get('/', function(req, res){
  var src;
  src = fs.readFileSync('views/api.md', 'utf8');
  return res.render('home.jade', {
    body: md(src, true)
  });
});
app.use(express['static'](__dirname + "/static"));
app.get('/favicon.ico', function(req, res){
  res.writeHead(404);
  return res.end("Not found");
});
app.listen(port);
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}
## API

Supported data sets: law, law-progress, company

(replace :dataset with law, company, etc.)

* listing api: /:dataset
  * skip: int
  * limit: int, 0 if unlimited
* detail api: /:dataset/:name
* search by api: /:dataset/by/:field/:value

### Example
* Law listing [/law?limit=20](/law?limit=20)
* Company detail: [/company/壹傳媒傳訊播放股份有限公司](/company/壹傳媒傳訊播放股份有限公司)
* Law proposal in progress: [/law-progress/by/status/一讀](/law-progress/by/status/一讀)

Note that all these queries return with "Access-Control-Allow-Origin: *" so that cross domain access is allowed.

## Source Code
* https://github.com/victorhsieh/mongo-serve

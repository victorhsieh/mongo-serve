## API

Supported data sets: law, law-progress, company

(replace :dataset with law, company, etc.)

* listing api: /:dataset
  * skip: int
  * limit: int, 0 if unlimited
* detail api: /:dataset/:name
* search by api: /:dataset/by/:field/:value

### Example
* 法律列表: [/law?limit=20](/law?limit=20)
* 憲法: [/law/中華民國憲法](/law/中華民國憲法)
* 公司明細: [/company/壹傳媒傳訊播放股份有限公司](/company/壹傳媒傳訊播放股份有限公司)
* 公司登記機關: [/company/by/登記機關/臺北市政府](/company/by/登記機關/臺北市政府)
* 提案（完成一讀）: [/law-progress/by/status/一讀](/law-progress/by/status/一讀)
* 提案明細: [/law-progress/0022994](/law-progress/0022994)

Note that all these queries return with "Access-Control-Allow-Origin: *" so that cross domain access is allowed.

## Source Code
* https://github.com/victorhsieh/mongo-serve

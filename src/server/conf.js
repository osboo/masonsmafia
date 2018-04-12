// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
let conf;
if (process.env.MASONS_ENV === 'TEST') {
  conf = {
    app: {
      port: 3000,
      sessionSecret: 'as9a9waiodnla21&&7aajwTaw7(',
      storeOptions: {
        db: 2,
      },
    },
    auth: {
      id: '4128469',
      secret: '5fPfSkh0MZGUMPd15F3y',
    },
    db: {
      dbName: 'masons_test',
      login: 'masons',
      password: 'masons',
      host: `${process.env.MYSQL_HOST}`,
    },
  };
} else {
  conf = {
    app: {
      port: 3000,
      sessionSecret: 'as9a9waiodnla21&&7aajwTaw7(',
      storeOptions: {
        db: 2,
      },
    },
    auth: {
      id: '4128469',
      secret: '5fPfSkh0MZGUMPd15F3y',
    },
    db: {
      dbName: 'masons',
      login: 'masons',
      password: 'masons',
      host: `${process.env.MYSQL_HOST}`,
    },
  };
}

module.exports = (section) => conf[section];

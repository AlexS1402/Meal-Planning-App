const redis = require("redis");
const redisClient = redis.createClient({
  socket: {
    host: "127.0.0.1",
    port: 6379,
  },
});

redisClient.on("error", (err) => console.log("Redis Client Error", err));

redisClient.connect().then(() => {
  console.log('Connected to Redis');
  // You can perform operations here that need to happen right after connecting
  clearCache();
}).catch((err) => {
  console.error('Redis condnection error:', err);
});

function clearCache() {
  // This function clears specific cache keys when called
  redisClient.del("recipes:*", (err, response) => {
    if (err) {
      console.error("Failed to clear cache", err);
    } else {
      console.log("Cache cleared", response);
    }
  });
}

module.exports = {
  redisClient,
  clearCache
};


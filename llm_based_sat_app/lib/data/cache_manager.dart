/* An in-memory cache manager for storing and retrieving key-value pairs. This class provides basic caching functionality without any expiration policy. It can be used to store frequently accessed data to improve performance. */
class CacheManager {
  /* Stores a value in the cache with the specified key.
  If a value already exists for the given key, it will be overwritten.
  - [key]: The unique identifier for the cached item.
  - [value]: The data to be stored in the cache. */
  static final Map<String, dynamic> _cache = {};

  static void setValue(String key, dynamic value) {
    _cache[key] = value;
  }

  static dynamic getValue(String key) {
    return _cache[key];
  }

  static void removeValue(String key) {
    _cache.remove(key);
  }
}
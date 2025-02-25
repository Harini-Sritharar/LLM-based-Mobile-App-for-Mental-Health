class CacheManager {
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
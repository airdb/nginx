CREATE TABLE `tab_ssl_fingerprint` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `client_ip` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fp_http2` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fp_ja3` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fp_ja3_hash` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=835384 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

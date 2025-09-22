#pragma once

#include "aws_extension.hpp"
#include "duckdb.hpp"
#include "duckdb/main/secret/secret.hpp"

namespace duckdb {

class ExtensionLoader;

struct CreateAwsSecretFunctions {
public:
	//! Register all CreateSecretFunctions
	static void Register(ExtensionLoader &instance);

	//! WARNING: not thread-safe, to be called on extension initialization once
	static void InitializeCurlCertificates(DatabaseInstance &db);
};

namespace aws {
// XXX: norms on both core && ext options, names? #defines, ns'd global symbols, struct?
//
// By default raise error when secret create cannot find credentials.
// For backward compatibility allow this to be disabled (set to false)
// via `SET aws__error_on_empty_secret_create = true;`
// XXX: note the aws__ namespace in key, seeking feedback
static const char *const ErrorOnEmptySecretCreate_Name = "aws__error_on_empty_secret_create";
static const bool ErrorOnEmptySecretCreate_Default = true;
}

} // namespace duckdb

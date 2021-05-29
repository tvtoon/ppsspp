#pragma once

#include <string>
#include <vector>

struct addrinfo;

namespace net {

#ifdef _WIN32
// Strictly only required on Win32, but all platforms should call it.
// NO, FUCK THAT SHIT!
void Init();
void Shutdown();
#endif

enum class DNSType {
	ANY = 0,
	IPV4 = 1,
	IPV6 = 2,
};

bool DNSResolve(const std::string &host, const std::string &service, addrinfo **res, std::string &error, DNSType type = DNSType::ANY);
void DNSResolveFree(addrinfo *res);
bool GetIPList(std::vector<std::string>& IP4s);

int inet_pton(int af, const char* src, void* dst);
}  // namespace net

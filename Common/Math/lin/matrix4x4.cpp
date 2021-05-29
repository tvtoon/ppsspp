#include "Common/Math/lin/matrix4x4.h"

#include <cstdio>

#include "Common/Math/lin/vec3.h"
#include "Common/Math/fast/fast_matrix.h"

#ifdef _WIN32
#undef far
#undef near
#endif

// See http://code.google.com/p/oolongengine/source/browse/trunk/Oolong+Engine2/Math/neonmath/neon_matrix_impl.cpp?spec=svn143&r=143	when we need speed
// no wait. http://code.google.com/p/math-neon/

namespace Lin {

Matrix4x4 Matrix4x4::transpose() const
{
	Matrix4x4 out;
	out.m4x4float.xx = m4x4float.xx;
out.m4x4float.xy = m4x4float.yx;
out.m4x4float.xz = m4x4float.zx;
out.m4x4float.xw = m4x4float.wx;
	out.m4x4float.yx = m4x4float.xy;
out.m4x4float.yy = m4x4float.yy;
out.m4x4float.yz = m4x4float.zy;
out.m4x4float.yw = m4x4float.wy;
	out.m4x4float.zx = m4x4float.xz;
out.m4x4float.zy = m4x4float.yz;
out.m4x4float.zz = m4x4float.zz;
out.m4x4float.zw = m4x4float.wz;
	out.m4x4float.wx = m4x4float.xw;
out.m4x4float.wy = m4x4float.yw;
out.m4x4float.wz = m4x4float.zw;
out.m4x4float.ww = m4x4float.ww;
	return out;
}

Matrix4x4 Matrix4x4::operator * (const Matrix4x4 &other) const 
{
	Matrix4x4 temp;
	fast_matrix_mul_4x4(temp.m, other.m, this->m);
	return temp;
}

void Matrix4x4::setViewFrame(const Vec3 &pos, const Vec3 &vRight, const Vec3 &vView, const Vec3 &vUp) {
	m4x4float.xx = vRight.x;
m4x4float.xy = vUp.x;
m4x4float.xz=vView.x;
m4x4float.xw = 0.0f;
	m4x4float.yx = vRight.y;
m4x4float.yy = vUp.y;
m4x4float.yz=vView.y;
m4x4float.yw = 0.0f;
	m4x4float.zx = vRight.z;
m4x4float.zy = vUp.z;
m4x4float.zz=vView.z;
m4x4float.zw = 0.0f;

	m4x4float.wx = -pos * vRight;
	m4x4float.wy = -pos * vUp;
	m4x4float.wz = -pos * vView;
	m4x4float.ww = 1.0f;
}

void Matrix4x4::setOrtho(float left, float right, float bottom, float top, float near, float far) {
	empty();
	m4x4float.xx = 2.0f / (right - left);
	m4x4float.yy = 2.0f / (top - bottom);
	m4x4float.zz = 2.0f / (far - near);
	m4x4float.wx = -(right + left) / (right - left);
	m4x4float.wy = -(top + bottom) / (top - bottom);
	m4x4float.wz = -(far + near) / (far - near);
	m4x4float.ww = 1.0f;
}

void Matrix4x4::setOrthoD3D(float left, float right, float bottom, float top, float near, float far) {
	empty();
	m4x4float.xx = 2.0f / (right - left);
	m4x4float.yy = 2.0f / (top - bottom);
	m4x4float.zz = 1.0f / (far - near);
	m4x4float.wx = -(right + left) / (right - left);
	m4x4float.wy = -(top + bottom) / (top - bottom);
	m4x4float.wz = -near / (far - near);
	m4x4float.ww = 1.0f;
}

void Matrix4x4::setOrthoVulkan(float left, float right, float top, float bottom, float near, float far) {
	empty();
	m4x4float.xx = 2.0f / (right - left);
	m4x4float.yy = 2.0f / (bottom - top);
	m4x4float.zz = 1.0f / (far - near);
	m4x4float.wx = -(right + left) / (right - left);
	m4x4float.wy = -(top + bottom) / (bottom - top);
	m4x4float.wz = -near / (far - near);
	m4x4float.ww = 1.0f;
}

void Matrix4x4::toText(char *buffer, int len) const {
	snprintf(buffer, len, "%f %f %f %f\n%f %f %f %f\n%f %f %f %f\n%f %f %f %f\n",
		m4x4float.xx,m4x4float.xy,m4x4float.xz,m4x4float.xw,
		m4x4float.yx,m4x4float.yy,m4x4float.yz,m4x4float.yw,
		m4x4float.zx,m4x4float.zy,m4x4float.zz,m4x4float.zw,
		m4x4float.wx,m4x4float.wy,m4x4float.wz,m4x4float.ww);
	buffer[len - 1] = '\0';
}

void Matrix4x4::print() const {
	char buffer[256];
	toText(buffer, 256);
	puts(buffer);
}

}

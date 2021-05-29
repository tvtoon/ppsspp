#ifndef _MATH_LIN_MATRIX4X4_H
#define _MATH_LIN_MATRIX4X4_H

#include "Common/Math/lin/vec3.h"

namespace Lin {

class Quaternion;

class Matrix4x4 {
public:
	union {
		struct {
			float xx, xy, xz, xw;
			float yx, yy, yz, yw;
			float zx, zy, zz, zw;
			float wx, wy, wz, ww;
		} m4x4float;
		float m[16];
	};

	const Vec3 right() const {return Vec3(m4x4float.xx, m4x4float.xy, m4x4float.xz);}
	const Vec3 up()		const {return Vec3(m4x4float.yx, m4x4float.yy, m4x4float.yz);}
	const Vec3 front() const {return Vec3(m4x4float.zx, m4x4float.zy, m4x4float.zz);}
	const Vec3 move()	const {return Vec3(m4x4float.wx, m4x4float.wy, m4x4float.wz);}

	const float &operator[](int i) const {
		return *(((const float *)this) + i);
	}
	float &operator[](int i) {
		return *(((float *)this) + i);
	}
	Matrix4x4 operator * (const Matrix4x4 &other) const ;
	void operator *= (const Matrix4x4 &other) {
		*this = *this * other;
	}
	const float *getReadPtr() const {
		return (const float *)this;
	}
	void empty() {
		memset(this, 0, 16 * sizeof(float));
	}
	static Matrix4x4 identity() {
		Matrix4x4 id;
		id.setIdentity();
		return id;
	}
	void setIdentity() {
		empty();
		m4x4float.xx = m4x4float.yy = m4x4float.zz = m4x4float.ww = 1.0f;
	}
	void setTranslation(const Vec3 &trans) {
		setIdentity();
		m4x4float.wx = trans.x;
		m4x4float.wy = trans.y;
		m4x4float.wz = trans.z;
	}

	Matrix4x4 transpose() const;

	// Exact angles to avoid any artifacts.
	void setRotationZ90() {
		empty();
		float c = 0.0f;
		float s = 1.0f;
		m4x4float.xx = c;
                m4x4float.xy = s;
		m4x4float.yx = -s;
                m4x4float.yy = c;
		m4x4float.zz = 1.0f;
		m4x4float.ww = 1.0f;
	}
	void setRotationZ180() {
		empty();
		float c = -1.0f;
		float s = 0.0f;
		m4x4float.xx = c;
m4x4float.xy = s;
		m4x4float.yx = -s;
m4x4float.yy = c;
		m4x4float.zz = 1.0f;
		m4x4float.ww = 1.0f;
	}
	void setRotationZ270() {
		empty();
		float c = 0.0f;
		float s = -1.0f;
		m4x4float.xx = c;
m4x4float.xy = s;
		m4x4float.yx = -s;
m4x4float.yy = c;
		m4x4float.zz = 1.0f;
		m4x4float.ww = 1.0f;
	}

	void setOrtho(float left, float right, float bottom, float top, float near, float far);
	void setOrthoD3D(float left, float right, float bottom, float top, float near, float far);
	void setOrthoVulkan(float left, float right, float top, float bottom, float near, float far);

	void setViewFrame(const Vec3 &pos, const Vec3 &right, const Vec3 &forward, const Vec3 &up);
	void toText(char *buffer, int len) const;
	void print() const;

	void translateAndScale(const Vec3 &trans, const Vec3 &scale) {
		m4x4float.xx = m4x4float.xx * scale.x + m4x4float.xw * trans.x;
		m4x4float.xy = m4x4float.xy * scale.y + m4x4float.xw * trans.y;
		m4x4float.xz = m4x4float.xz * scale.z + m4x4float.xw * trans.z;

		m4x4float.yx = m4x4float.yx * scale.x + m4x4float.yw * trans.x;
		m4x4float.yy = m4x4float.yy * scale.y + m4x4float.yw * trans.y;
		m4x4float.yz = m4x4float.yz * scale.z + m4x4float.yw * trans.z;

		m4x4float.zx = m4x4float.zx * scale.x + m4x4float.zw * trans.x;
		m4x4float.zy = m4x4float.zy * scale.y + m4x4float.zw * trans.y;
		m4x4float.zz = m4x4float.zz * scale.z + m4x4float.zw * trans.z;

		m4x4float.wx = m4x4float.wx * scale.x + m4x4float.ww * trans.x;
		m4x4float.wy = m4x4float.wy * scale.y + m4x4float.ww * trans.y;
		m4x4float.wz = m4x4float.wz * scale.z + m4x4float.ww * trans.z;
	}
};

}  // namespace Lin

#endif	// _MATH_LIN_MATRIX4X4_H


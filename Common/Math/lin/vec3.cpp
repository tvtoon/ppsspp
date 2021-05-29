#include <stdio.h>

#include "Common/Math/lin/vec3.h"
#include "Common/Math/lin/matrix4x4.h"

namespace Lin {

Vec3 Vec3::operator *(const Matrix4x4 &m) const {
	return Vec3(x*m.m4x4float.xx + y*m.m4x4float.yx + z*m.m4x4float.zx + m.m4x4float.wx,
		x*m.m4x4float.xy + y*m.m4x4float.yy + z*m.m4x4float.zy + m.m4x4float.wy,
		x*m.m4x4float.xz + y*m.m4x4float.yz + z*m.m4x4float.zz + m.m4x4float.wz);
}

Vec3 Vec3::rotatedBy(const Matrix4x4 &m) const {
	return Vec3(x*m.m4x4float.xx + y*m.m4x4float.yx + z*m.m4x4float.zx,
		x*m.m4x4float.xy + y*m.m4x4float.yy + z*m.m4x4float.zy,
		x*m.m4x4float.xz + y*m.m4x4float.yz + z*m.m4x4float.zz);
}

}  // namespace Lin

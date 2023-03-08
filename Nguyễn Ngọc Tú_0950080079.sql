--a. Tạo các login; tạo các user khai thác CSDL AdventureWorks2008R2 cho các nhân viên nêu
--trên (tên login trùng tên user). (1đ)
-- Tạo login
CREATE LOGIN [John] WITH PASSWORD = 'password123';

-- Tạo user và kết nối với login
CREATE USER [John] FOR LOGIN [John];
--tạo trưởng user Trnhóm và QL
CREATE LOGIN [TN TruongNhom] WITH PASSWORD = 'password';
CREATE USER [TN TruongNhom] FOR LOGIN [TN TruongNhom];


CREATE LOGIN [QL QuanLy] WITH PASSWORD = 'password';
CREATE USER [QL QuanLy] FOR LOGIN [QL QuanLy];

--b. Phân quyền để các nhân viên hoàn thành nhiệm vụ được phân công. Lưu ý : Admin chỉ cấp
--quyền cho trưởng nhóm TN và quản lý QL. Quyền của nhân viên NV được trưởng nhóm cấp.
--(1.5đ)

--1.Cấp quyền cho trưởng nhóm
GRANT SELECT, UPDATE ON Sales.Store TO [TN TruongNhom];
--2.Cấp quyền cho quản lý
GRANT SELECT, INSERT, UPDATE, DELETE ON Sales.Store TO [QL QuanLy];
--3.Cho phép trưởng nhóm TN cấp quyền cho nhân viên NV
GRANT SELECT, UPDATE ON Sales.Store TO [TN TruongNhom] WITH GRANT OPTION;
/*
c. Đăng nhập phù hợp, mở cửa sổ query tương ứng và viết lệnh để:
- trưởng nhóm TN sửa 1 dòng dữ liệu tùy ý,
- nhân viên NV xóa 1 dòng dữ liệu tùy ý và
- nhân viên QL xem lại kết quả thực hiện của 2 user trên.
(Lưu ý: Đặt tên các cửa sổ query làm việc ứng với các nhân viên là TN, NV, QL và lưu các query
này vào thư mục bài làm) (3đ)
*/
--đăng nhập với tài khoản của nhóm trưởng
USE AdventureWorks2008R2;
GO
EXECUTE AS LOGIN = 'TN TruongNhom';
GO
--Trưởng nhóm TN sửa 1 dòng dữ liệu tùy ý:
USE AdventureWorks2008R2;
GO
UPDATE Sales.Store
SET Name = 'New Name'
WHERE BusinessEntityID = 1;
GO
--Nhân viên NV xóa 1 dòng dữ liệu tùy ý:
USE AdventureWorks2008R2;
GO
DELETE FROM Sales.Store
WHERE BusinessEntityID = 2;
GO
--Nhân viên QL xem lại kết quả thực hiện của 2 user trên
USE AdventureWorks2008R2;
GO
SELECT * FROM Sales.Store;
GO
--d. Ai có thể sửa được dữ liệu bảng Production.Product ? Viết lệnh cụ thể và giải thích vì sao? (1đ)
/*
Các cá nhân có thể sửa đổi dữ liệu trong bảng Production.Product phụ thuộc vào các quyền được cấp cho họ bởi người quản trị cơ sở dữ liệu. Trong trường hợp này, nó không được chỉ định ai đã được cấp
Để xác định ai có quyền sửa đổi dữ liệu trong bảng Production.Product 
*/
USE AdventureWorks2008R2;
GO
SELECT *
FROM sys.database_permissions
WHERE OBJECT_NAME(major_id) = 'Product'
/*
Truy vấn này sẽ trả về danh sách tất cả các quyền ở cấp cơ sở dữ liệu đã được cấp trên bảng Sản phẩm. Bạn có thể tìm kiếm các quyền liên quan đến hoạt động CẬP NHẬT, CHÈN và XÓA để xác định người dùng hoặc vai trò nào có khả năng sửa đổi dữ liệu trong bảng.
*/

/*
thực hiện truy vấn sau để kiểm tra cụ thể người dùng hoặc vai trò với quyền UPDATE trên bảng Production.Product
*/
USE AdventureWorks2008R2;
GO
SELECT user_name(grantee_principal_id) AS UserName, permission_name
FROM sys.database_permissions
WHERE OBJECT_NAME(major_id) = 'Product'
AND permission_name = 'UPDATE'
/*
Truy vấn này sẽ trả về danh sách tất cả người dùng hoặc vai trò đã được cấp quyền UPDATE trên bảng Sản phẩm
*/

/*
*/
--e. Nhân viên NV nghỉ việc, trưởng nhóm hãy thu hồi quyền cấp cho nhân viên NV này. (1đ)
-- Để thu hồi quyền cấp của nhân viên NV, ta cần sử dụng lệnh REVOKE để thu hồi các quyền đã được phân bổ cho user này
USE AdventureWorks2008R2;
GO
SELECT * FROM sys.tables WHERE name = 'ProductInventory';

REVOKE SELECT, UPDATE, INSERT, DELETE ON Production.ProductInventory FROM [John];
--f. Nhóm 1 hoàn thành dự án, admin hãy vô hiệu hóa các hoạt động của nhóm này trên CSDL
--(0.5đ)
--Thu hồi quyền đăng nhập của các user trong nhóm 1
USE AdventureWorks2008R2;
REVOKE CONNECT SQL FROM TN;
REVOKE CONNECT SQL FROM NV;

--Thu hồi quyền truy cập vào các đối tượng trong CSDL của nhóm 1:
USE AdventureWorks2008R2;
REVOKE SELECT, INSERT, UPDATE, DELETE ON Production.ProductInventory FROM TN;
REVOKE SELECT, INSERT, UPDATE, DELETE ON Production.ProductInventory FROM NV;



import XLSX from 'xlsx';

// 假设你的 JSON 数据如下
const jsonData = [
  { name: "John", age: 30, city: "New York" },
  { name: "Peter", age: 25, city: "Paris" },
  { name: "Jane", age: 40, city: "London" }
];

function generateExcel(jsonData) {
  // 创建一个新的工作簿
  const workbook = XLSX.utils.book_new();

  // 将 JSON 数据转换为工作表
  const worksheet = XLSX.utils.json_to_sheet(jsonData);

  // 将工作表添加到工作簿
  XLSX.utils.book_append_sheet(workbook, worksheet, "Sheet1");

  // 生成 Excel 文件
  const excelBuffer = XLSX.write(workbook, { bookType: 'xlsx', type: 'array' });

  // 创建 Blob 对象
  const blob = new Blob([excelBuffer], { type: "application/octet-stream" });

  // 创建下载链接
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = 'data.xlsx';

  // 触发下载
  a.click();

  // 释放 URL 对象
  URL.revokeObjectURL(url);
}

// 调用函数生成和下载 Excel 文件
generateExcel(jsonData);

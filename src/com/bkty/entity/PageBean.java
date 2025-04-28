package com.bkty.entity;

import java.util.List;

public class PageBean<T> {
	private int index; // 当前页码
	private int size = 10; // 每页显示的记录数，默认10条
	private int totalCount; // 总记录数
	private int totalPage; // 总页数
	private List<T> list; // 当前页的数据集合
	private int[] numbers; // 页码数组

	public int getIndex() {
		return index;
	}

	public void setIndex(int index) {
		this.index = index;
	}

	public int getSize() {
		return size;
	}

	public void setSize(int size) {
		this.size = size;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
		// 计算总页数
		this.totalPage = (totalCount + size - 1) / size;

		// 计算页码数组
		numbers = new int[totalPage];
		for (int i = 0; i < totalPage; i++) {
			numbers[i] = i + 1;
		}
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public List<T> getList() {
		return list;
	}

	public void setList(List<T> list) {
		this.list = list;
	}

	public int[] getNumbers() {
		return numbers;
	}

	public void setNumbers(int[] numbers) {
		this.numbers = numbers;
	}

	@Override
	public String toString() {
		return "PageBean{" +
				"index=" + index +
				", size=" + size +
				", totalCount=" + totalCount +
				", totalPage=" + totalPage +
				", list=" + list +
				'}';
	}
}
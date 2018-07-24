package com.practice.model;

public class Sitemap {
	private String location;
	private String date;
	private String changeFrequency;
	private int priority;
	
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getChangeFrequency() {
		return changeFrequency;
	}
	public void setChangeFrequency(String changeFrequency) {
		this.changeFrequency = changeFrequency;
	}
	public int getPriority() {
		return priority;
	}
	public void setPriority(int priority) {
		this.priority = priority;
	}
}

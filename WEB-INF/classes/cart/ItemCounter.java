package cart;

import javax.sql.*;
import java.io.IOException;
import javax.servlet.http.*;
import javax.servlet.*;
import java.lang.Math;
import java.util.*;

public final class ItemCounter {
	private String isbn;
	private int quantity;


	public ItemCounter(String aIsbn) {
		isbn = aIsbn;
		quantity = 0;
	}

	public ItemCounter(String aIsbn, int q) {
		isbn = aIsbn;
		setQuantity(q);
	}

	public String isbn() {
		return isbn;
	}

	public int quantity() {
		return quantity;
	}

	public void addQuantity(int q) {
		quantity += q;
	}

	public void setQuantity(int q) {
		quantity = q;
	}
}
package com.hotel.modelo;

public class Categoria {
    private int codCategoria;
    private String detalle;

    public Categoria() {
    }

    public Categoria(int codCategoria, String detalle) {
        this.codCategoria = codCategoria;
        this.detalle = detalle;
    }

    public int getCodCategoria() {
        return codCategoria;
    }

    public void setCodCategoria(int codCategoria) {
        this.codCategoria = codCategoria;
    }

    public String getDetalle() {
        return detalle;
    }

    public void setDetalle(String detalle) {
        this.detalle = detalle;
    }
}


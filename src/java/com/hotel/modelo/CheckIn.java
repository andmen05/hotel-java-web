package com.hotel.modelo;
import java.sql.Timestamp;

public class CheckIn {
    private int idCheckin;
    private Timestamp fechaIngresoCheckin;
    private Timestamp fechaSalidaChecking;
    private int noches;
    private int habitacion;
    private int idCliente;
    private String transporte;
    private String motivoViaje;
    private String procedencia;
    private int acompanantes;
    private String estado;

    public CheckIn() {
    }

    public CheckIn(int idCheckin, Timestamp fechaIngresoCheckin, Timestamp fechaSalidaChecking, int noches, 
                   int habitacion, int idCliente, String transporte, String motivoViaje, String procedencia, 
                   int acompanantes, String estado) {
        this.idCheckin = idCheckin;
        this.fechaIngresoCheckin = fechaIngresoCheckin;
        this.fechaSalidaChecking = fechaSalidaChecking;
        this.noches = noches;
        this.habitacion = habitacion;
        this.idCliente = idCliente;
        this.transporte = transporte;
        this.motivoViaje = motivoViaje;
        this.procedencia = procedencia;
        this.acompanantes = acompanantes;
        this.estado = estado;
    }

    public int getIdCheckin() {
        return idCheckin;
    }

    public void setIdCheckin(int idCheckin) {
        this.idCheckin = idCheckin;
    }

    public Timestamp getFechaIngresoCheckin() {
        return fechaIngresoCheckin;
    }

    public void setFechaIngresoCheckin(Timestamp fechaIngresoCheckin) {
        this.fechaIngresoCheckin = fechaIngresoCheckin;
    }

    public Timestamp getFechaSalidaChecking() {
        return fechaSalidaChecking;
    }

    public void setFechaSalidaChecking(Timestamp fechaSalidaChecking) {
        this.fechaSalidaChecking = fechaSalidaChecking;
    }

    public int getNoches() {
        return noches;
    }

    public void setNoches(int noches) {
        this.noches = noches;
    }

    public int getHabitacion() {
        return habitacion;
    }

    public void setHabitacion(int habitacion) {
        this.habitacion = habitacion;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public String getTransporte() {
        return transporte;
    }

    public void setTransporte(String transporte) {
        this.transporte = transporte;
    }

    public String getMotivoViaje() {
        return motivoViaje;
    }

    public void setMotivoViaje(String motivoViaje) {
        this.motivoViaje = motivoViaje;
    }

    public String getProcedencia() {
        return procedencia;
    }

    public void setProcedencia(String procedencia) {
        this.procedencia = procedencia;
    }

    public int getAcompanantes() {
        return acompanantes;
    }

    public void setAcompanantes(int acompanantes) {
        this.acompanantes = acompanantes;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}


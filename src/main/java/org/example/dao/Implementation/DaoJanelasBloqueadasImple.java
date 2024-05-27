package org.example.dao.Implementation;

import org.example.database.ConexaoMysql;
import org.example.database.ConexaoSQLServer;
import org.example.entities.JanelasBloqueadas;
import org.example.entities.Maquina;
import org.example.entities.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DaoJanelasBloqueadasImple implements org.example.dao.DaoJanelasBloqueadas {

    public List<String> buscarJanelasBloqueadasMysql(List<Integer> idCard) {
        Connection connBloqueio = null;
        ResultSet rs = null;
        PreparedStatement ps = null;

        JanelasBloqueadas janelasBloqueadas = new JanelasBloqueadas();

        if (connBloqueio == null) {
            connBloqueio = ConexaoMysql.getConection();
        }

        for (Integer idCardVez : idCard) {
            try {
                ps = connBloqueio.prepareStatement("""
                        SELECT p.titulo_processo
                        FROM processos_janelas AS p
                        JOIN card_tem_processo AS card ON p.id_processo = card.fk_processo_card
                        WHERE card.ativo = 1 AND card.fk_card = ?;
                        """);
                ps.setInt(1, idCardVez);
                rs = ps.executeQuery();
                while (rs.next()) {
                    janelasBloqueadas.addBloqueioNaLista(rs.getString("titulo_processo"));
                }
            } catch (Exception e) {
                System.out.println("Erro ao buscar janelas bloqueadas SQLSERVER: " + e.getMessage());
                connBloqueio = null;
            }
        }
        return janelasBloqueadas.exibirLista();
    }

    public List<JanelasBloqueadas> buscarJanelasBloqueadasSqlServer(List<Integer> idCard) {
        Connection connAtivo = null;
        ResultSet rs = null;
        PreparedStatement ps = null;

        List<JanelasBloqueadas> listaJanelasBloqueadas = new ArrayList<>();

        for (Integer idCardVez : idCard) {
            try {
                if (connAtivo == null) {
                    connAtivo = ConexaoSQLServer.getConection();
                }
                ps = connAtivo.prepareStatement("""
                        SELECT p.titulo_processo, fk_card
                        FROM processos_janelas AS p
                        JOIN card_tem_processo AS card ON p.id_processo = card.fk_processo_card
                        WHERE card.ativo = 1 AND card.fk_card = ?;
                        """);
                ps.setInt(1, idCardVez);
                rs = ps.executeQuery();
                while (rs.next()) {
                    JanelasBloqueadas janelasBloqueadas = new JanelasBloqueadas();
                    janelasBloqueadas.setNome(rs.getString("titulo_processo"));
                    janelasBloqueadas.setCategoria(rs.getInt("fk_card"));
                    listaJanelasBloqueadas.add(janelasBloqueadas);
                }
            } catch (Exception e) {
                System.out.println("Erro ao buscar janelas bloqueadas SQLSERVER: " + e.getMessage());
                connAtivo = null;
            }
        }
        return listaJanelasBloqueadas;
    }

    public List<Integer> buscarCadsAtivosNoSetorSql(Integer idSetor, Integer idEmpresa) {
        List<Integer> idCards = new ArrayList<>();

        Connection conn = null;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            conn = ConexaoSQLServer.getConection();

            ps = conn.prepareStatement("""
                    SELECT * FROM setor_tem_categoria WHERE ativo = 1 AND fk_empresa = ? AND fk_setor =?;
                    """);
            ps.setInt(1, idEmpresa);
            ps.setInt(2, idSetor);
            rs = ps.executeQuery();
            while (rs.next()) {
                idCards.add(rs.getInt("id_card"));
            }
        } catch (Exception e) {
            System.out.println("Erro ao buscar janelas bloqueadas SQLSERVER: " + e.getMessage());
        }
        return idCards;
    }

    public void inserirDadosBloqueio(Maquina maquina, Integer categoria) {
        Connection conn;
        PreparedStatement ps;
        ResultSet rt;

        try {
            conn = ConexaoSQLServer.getConection();
            ps = conn.prepareStatement("""
                    insert into historico_bloqueios (fk_empresa, fk_categoria, fk_setor) values (?,?,?);                                                                                                            
                    """);
            ps.setInt(1, maquina.getIdEmpresa());
            ps.setInt(2, categoria);
            ps.setInt(3, maquina.getIdSetor());

            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Erro ao inserir o hitorico" + e.getMessage());
        }
    }

    public void alertaBloqueio(Maquina maquina, String nomeProcesso) {
        Connection conn;
        PreparedStatement ps;
        ResultSet rt;
        String descricaoAlerta = "Atenção a " + maquina + " tentou acessar o processo " + nomeProcesso;
        try {
            conn = ConexaoSQLServer.getConection();
            ps = conn.prepareStatement("""
                    INSERT INTO alerta (fk_maquina, descricao_alerta)
                                        VALUES (?, ?);                    """);
            ps.setInt(1, maquina.getId());
            ps.setString(2, descricaoAlerta);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Erro ao inserir o hitorico" + e.getMessage());
        }
    }
}

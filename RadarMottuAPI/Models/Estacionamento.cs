namespace RadarMottuAPI.Models
{
    public class Estacionamento
    {
        public int Id { get; set; }
        public string Nome { get; set; } = string.Empty;
        public string Endereco { get; set; } = string.Empty;
        public int Capacidade { get; set; }
        public string Tipo { get; set; } = string.Empty; // Coberto ou Descoberto
        public bool Ativo { get; set; }

        public List<Moto>? Motos { get; set; }
    }
}

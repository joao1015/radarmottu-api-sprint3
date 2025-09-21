using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RadarMottuAPI.Data;
using RadarMottuAPI.Models;

namespace RadarMottuAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PosicionamentosController : ControllerBase
    {
        private readonly AppDbContext _context;

        public PosicionamentosController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Posicionamento>>> GetAll()
        {
            return await _context.Posicionamentos.Include(p => p.Moto).ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Posicionamento>> GetById(int id)
        {
            var pos = await _context.Posicionamentos.Include(p => p.Moto).FirstOrDefaultAsync(p => p.Id == id);
            return pos == null ? NotFound() : Ok(pos);
        }

        [HttpPost]
        public async Task<ActionResult<Posicionamento>> Create(Posicionamento pos)
        {
            _context.Posicionamentos.Add(pos);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetById), new { id = pos.Id }, pos);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, Posicionamento pos)
        {
            if (id != pos.Id) return BadRequest();

            _context.Entry(pos).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var pos = await _context.Posicionamentos.FindAsync(id);
            if (pos == null) return NotFound();

            _context.Posicionamentos.Remove(pos);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}

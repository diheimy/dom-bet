#!/bin/bash
# =====================================================
# Dom Bet - Database Migration Script
# Uso: ./scripts/db-migrate.sh [migration_file.sql]
# =====================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DB_DIR="$PROJECT_ROOT/db"

# Carregar variáveis de ambiente
if [ -f "$PROJECT_ROOT/.env" ]; then
    export $(grep -v '^#' "$PROJECT_ROOT/.env" | xargs)
fi

# Defaults
POSTGRES_USER="${POSTGRES_USER:-dombet_user}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-dombet_secure_pass_2026}"
POSTGRES_DB="${POSTGRES_DB:-dombet_db}"
HOST="${HOST:-localhost}"
PORT="${PORT:-5432}"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Função para executar migration
run_migration() {
    local migration_file="$1"

    if [ ! -f "$migration_file" ]; then
        log_error "Migration file not found: $migration_file"
        exit 1
    fi

    log_info "Running migration: $migration_file"

    PGPASSWORD="$POSTGRES_PASSWORD" psql \
        -h "$HOST" \
        -p "$PORT" \
        -U "$POSTGRES_USER" \
        -d "$POSTGRES_DB" \
        -f "$migration_file"

    log_info "Migration completed: $migration_file"
}

# Função para executar todas as migrations
run_all_migrations() {
    log_info "Running all migrations from $DB_DIR/init/"

    # Executar init scripts (ordem alfabética)
    for script in "$DB_DIR"/init/*.sql; do
        if [ -f "$script" ]; then
            run_migration "$script"
        fi
    done

    # Executar migrations manuais (ordem alfabética)
    for script in "$DB_DIR"/migrations/*.sql; do
        if [ -f "$script" ]; then
            log_info "Applying manual migration: $script"
            run_migration "$script"
        fi
    done

    log_info "All migrations completed!"
}

# Função para verificar status do banco
check_db_status() {
    log_info "Checking database connection..."

    if PGPASSWORD="$POSTGRES_PASSWORD" psql \
        -h "$HOST" \
        -p "$PORT" \
        -U "$POSTGRES_USER" \
        -d "$POSTGRES_DB" \
        -c "SELECT 1" > /dev/null 2>&1; then
        log_info "Database connection successful!"
        return 0
    else
        log_error "Cannot connect to database"
        return 1
    fi
}

# Função para listar tabelas
list_tables() {
    log_info "Listing database tables..."

    PGPASSWORD="$POSTGRES_PASSWORD" psql \
        -h "$HOST" \
        -p "$PORT" \
        -U "$POSTGRES_USER" \
        -d "$POSTGRES_DB" \
        -c "\dt"
}

# Help
show_help() {
    echo "Dom Bet Database Migration Tool"
    echo ""
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  migrate [file.sql]  Run a specific migration or all if no file specified"
    echo "  status              Check database connection status"
    echo "  tables              List all tables in the database"
    echo "  help                Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 migrate                          # Run all migrations"
    echo "  $0 migrate db/init/001_schema.sql   # Run specific migration"
    echo "  $0 status                           # Check DB connection"
    echo ""
}

# Main
case "${1:-migrate}" in
    migrate)
        if [ -n "$2" ]; then
            run_migration "$2"
        else
            run_all_migrations
        fi
        ;;
    status)
        check_db_status
        ;;
    tables)
        list_tables
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        log_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac

export interface Group {
    name: number;
    connections: Connection[];
}

export interface Connection {
    connectionId: string;
    userName:    string;
}